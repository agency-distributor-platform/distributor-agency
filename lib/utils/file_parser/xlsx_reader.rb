module Utils
  class XlsxReader
    attr_reader :spreadsheet

    def initialize(file)
      @spreadsheet = Roo::Spreadsheet.open(file)
      @spreadsheet.default_sheet = @spreadsheet.sheets[0]
      @headers = get_headers
    end

    def basic_validation
      raise Utils::FileParserError.new(Constants::FILE_HAS_MORE_THAN_ONE_SHEET_MESSAGE) if spreadsheet.sheets.length > 1
      raise Utils::FileParserError.new(Constants::NO_RECORDS_FOUND_MESSAGE) if spreadsheet.last_row == 0
    end

    def headers_validation(expected_headers)
      are_equal = expected_headers.sort == @headers.sort
      raise Utils::FileParserError.new(Constants::HEADERS_VALIDATION_FAILED) unless are_equal
    end

    def get_headers
      spreadsheet.row(spreadsheet.first_row)
    end

    def read
      records = []
      headers = nil
      spreadsheet.each_row_streaming(pad_cells: true) do |row|
        row = row.map { |r| r.value if r.present? }
        if headers.blank?
          headers = row
          next
        end
        row = preprocess_row(row)
        next if row.compact.empty?

        records << Hash[headers.zip(row)].with_indifferent_access
      end
      
      return records
    end

    def preprocess_row(row)
      row.map do |value|
        value = value.gsub(/^\p{Space}*|\p{Space}*$/, '').strip if value.is_a?(String)
        value = nil if value.blank?

        value
      end
    end

    def row_count
      return @row_count unless @row_count.nil?

      return 0 if spreadsheet.last_row.blank?
      return 0 if preprocess_row(spreadsheet.row(1)).compact.empty?

      count = 0
      (2..spreadsheet.last_row).each do |row_number|
        next if preprocess_row(spreadsheet.row(row_number)).compact.empty?
        count += 1
      end

      @row_count = count
    end
  end
end
