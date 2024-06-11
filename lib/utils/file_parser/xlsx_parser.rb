module Utils
  class XlsxParser

    def get_reader(filepath)
      Utils::XlsxReader.new(filepath)
    end

    def write(file, records, sheetname: 'Bulk Upload')
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: sheetname) do |sheet|
          records.each do |record|
            sheet.add_row record
          end
        end
        p.serialize(file)
      end
      file
    end
  end
end
