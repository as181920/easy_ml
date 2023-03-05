require "matrix"

module EasyMl
  class ExpectationMaximizationClustering
    attr_reader :k_num, :data, :labels, :classes

    def initialize(k_num, data)
      @k_num = k_num
      @data = data
      setup_cluster
    end

    def to_s
      @partitions
    end

    def perform(iterations = 5)
      iterations.times do |idx|
        EasyMl.logger.info "#{self.class.name} perform iteration #{idx}"
        expect_maximize
      end
    end

    def restart
      setup_cluster
      expect
    end

    def good_enough?
      @labels.all? do |probabilities|
        probabilities.max > 0.9
      end
    end

    private

      def setup_cluster
        @labels = Array.new(@data.row_size) { Array.new(k_num) { 1.0 / k_num } }
        @width = @data.column_size

        pick_k_random_indices = @data.row_size.times.to_a.shuffle.sample(k_num)

        @classes = Array.new(k_num) { { means: @data.row(pick_k_random_indices.shift), covariance: Matrix.identity(@width) * 0.2 } }
        @partitions = []
      end

      def expect_maximize
        expect
        maximize
      end

      def expect # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @classes.each_with_index do |klass, i|
          EasyMl.logger.info "#{self.class.name} expect class index: #{i}"
          inv_cov = klass[:covariance].regular? ? klass[:covariance].inv : (klass[:covariance] - (0.0001 * Matrix.identity(@width))).inv
          d = Math.sqrt(klass[:covariance].det)

          @data.row_vectors.each_with_index do |row, j|
            rel = row - klass[:means]
            p = d * Math.exp(-0.5 * fast_product(rel, inv_cov))
            @labels[j][i] = p
          end
        end

        @labels = @labels.map.each_with_index do |probabilities, i|
          @partitions[i] = probabilities.index(probabilities.max)
          sum = probabilities.sum
          sum.zero? ? probabilities.map { 1.0 / k_num } : probabilities.map { |p| p / sum.to_f }
        end
      end

      def fast_product(rel, inv_cov)
        sum = 0

        inv_cov.column_count.times do |j|
          local_sum = 0
          (0...rel.size).each { |k| local_sum += rel[k] * inv_cov[k, j] }
          sum += local_sum * rel[j]
        end

        sum
      end

      def maximize # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @classes.each_with_index do |_klass, i|
          EasyMl.logger.info "#{self.class.name} maximize class index: #{i}"
          sum = Array.new(@width) { 0 }
          num = 0

          @data.each_with_index do |_row, j|
            p = @labels[j][i]

            @width.times do |k|
              sum[k] += p * @data[j, k]
            end

            num += p
          end

          mean = sum.map { |s| s / num }
          covariance = Matrix.zero(@width, @width)

          @data.row_vectors.each_with_index do |row, j|
            p = @labels[j][i]
            rel = row - Vector[*mean]
            covariance += Matrix.build(@width, @width) { |m, n| rel[m] * rel[n] * p }
          end

          covariance = (1.0 / num) * covariance

          @classes[i][:means] = Vector[*mean]
          @classes[i][:covariance] = covariance
        end
      end
  end
end

# data = Matrix[
#   [1,1],
#   [1,2],
#   [1,3],
#   [8,4],
#   [8,6],
#   [8,8]
# ]
