module Songkick
  module OAuth2

    class Schema
      def self.migrate
        ActiveRecord::Base.logger ||= Logger.new(StringIO.new)
        if ActiveRecord.version.version >= '6.0'
          ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::Base.connection.schema_migration).up
        elsif ActiveRecord.version.version >= '5.2'
          ActiveRecord::MigrationContext.new(migrations_path).up
        else
          ActiveRecord::Migrator.up(migrations_path)
        end
      end
      class << self
        alias :up :migrate
      end

      def self.rollback
        ActiveRecord::Base.logger ||= Logger.new(StringIO.new)
        if ActiveRecord.version.version >= '6.0'
          ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::Base.connection.schema_migration).down
        elsif ActiveRecord.version.version >= '5.2'
          ActiveRecord::MigrationContext.new(migrations_path).down
        else
          ActiveRecord::Migrator.down(migrations_path)
        end
      end
      class << self
        alias :down :rollback
      end

      def self.migrations_path
        File.expand_path('../schema', __FILE__)
      end
    end
  end
end
