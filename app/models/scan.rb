require 'json'
require 'fileutils'

class Scan
  include Virtus

  # TODO: Config for test.
  SCANS_PATH = Rails.root.join('db', 'scans')
  BUCKETS = 1000
  DATE_FORMAT = '%Y-%m-%d %H:%M:%S.%L' # 2013-08-10 08:35:03.895

  attribute :order_id, Integer
  attribute :order_code, String
  attribute :ticket_id, Integer
  attribute :ticket_code, String
  attribute :created_at, DateTime, :default => lambda { |scan,attr| DateTime.now }
  attribute :booth, String

  def self.create(attrs={})
    self.new(attrs).save!
  end

  def save!
    FileUtils.mkdir_p(
      File.join(SCANS_PATH, dir_hash(filename))
    )
    File.open(full_path, 'w') do |f|
      f.write self.to_json
    end
  end

  def self.find_all_by_order_code(order_code)
    # order_code, eg. S3-123ABCD
    Dir[File.join(SCANS_PATH, '**', "#{order_code}-* *")].map do |filename|
      self.from_json(File.read(filename))
    end
  end

  def self.find_all_by_ticket_code(ticket_code)
    # ticket_code is S3-123ABCD-01AB
    Dir[File.join(SCANS_PATH, '**', "#{ticket_code} *")].map do |filename|
      self.from_json(File.read(filename))
    end
  end

  def to_json
    JSON.pretty_generate(attributes)
  end

  def self.from_json(string)
    self.new(JSON.parse(string))
  end

  def filename
    "#{ticket_code} - #{created_at.strftime(DATE_FORMAT)} - #{booth}.json"
  end

  def full_path
    # eg. "499/S3-AN3XAMPL3 - 2013-08-10 08:35:03.895 - mobile1.json"
    File.join(SCANS_PATH, dir_hash(filename), filename)
  end

  def dir_hash(filename, buckets=BUCKETS)
    # (str -> int) mod 1000,
    # ie. a number between 0 and 999
    (filename.hash % buckets).to_s
  end
end
