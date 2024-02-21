# Database - Database class for accesing Firebase Cloud FireStore
require 'dotenv/load'
require 'google/cloud/firestore'

# Database - Class for interacting with Fireabase Firestore database
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
    ::Google::Cloud::Firestore.new(
      project_id: ENV['FIREBASE_PROJECT_ID'],
      credentials: JSON.parse(ENV['FIREBASE_CREDENTIALS'])
    )
  end
end
