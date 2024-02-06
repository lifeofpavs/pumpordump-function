# Database - Database class for accesing Firebase Cloud FireStore
require 'dotenv/load'

class Database
  @instance = nil

  private_class_method :new

  class << self
    attr_reader :instance
  end

  def self.client
    @client ||= setup_db
  end

  def self.setup_db
    Google::Cloud::Firestore.new(project_id: ENV['FIREBASE_PROJECT_ID'], credentials: 'credentials.json')
  end
end
