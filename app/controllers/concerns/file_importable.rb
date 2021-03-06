module FileImportable
  extend ActiveSupport::Concern

  VALID_MIME_TYPES = %w[text/csv].freeze

  def read_csv_file(file)
    return unless file.content_type == "text/csv"
    File.read(file, encoding: "UTF-8")
  end

  def initialize_import
    @errors = []
    @file = params.require(:file)
  end

  def validate_file_type
    @errors << "Unsupported file type, please upload a csv file only" if VALID_MIME_TYPES.exclude?(@file.content_type)
  end

  def validate_file_size
    @errors << "File is too big, must be smaller than 5MB" if @file.size > 5.megabytes
  end
end
