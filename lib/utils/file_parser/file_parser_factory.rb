module Utils
  class FileParserFactory
    def self.get_parser(extension)
      extension = extension.downcase
      case extension
      when 'xlsx'
        return Utils::XlsxParser.new
      else
        raise FileParserError, Constants::NOT_A_VALID_EXTENSION_MESSAGE
      end
    end
  end
end
