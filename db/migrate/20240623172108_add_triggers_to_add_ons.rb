class AddTriggersToAddOns < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      DROP PROCEDURE IF EXISTS on_create_trigger;
    SQL

    execute <<-SQL
    CREATE PROCEDURE on_create_trigger()
      BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
        END;

        START TRANSACTION;

        -- Drop the trigger if it exists
        DROP TRIGGER IF EXISTS add_ons_insert_trigger;

      CREATE TRIGGER add_ons_insert_trigger
      AFTER INSERT ON add_ons
      FOR EACH ROW
      BEGIN
          UPDATE item_mapping_records
          SET expenses = (
              SELECT SUM(amount)
              FROM add_ons
              WHERE item_mapping_record_id = NEW.item_mapping_record_id
          )
          WHERE id = NEW.item_mapping_record_id;
      END;
      COMMIT;
    SQL

    execute <<-SQL
      CALL on_create_trigger();
    SQL

    execute <<-SQL
      DROP PROCEDURE IF EXISTS on_update_trigger;
    SQL

  execute <<-SQL
  CREATE PROCEDURE on_update_trigger()
    BEGIN
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
      BEGIN
        ROLLBACK;
      END;

      START TRANSACTION;

      -- Drop the trigger if it exists
      DROP TRIGGER IF EXISTS add_ons_update_trigger;

      CREATE TRIGGER add_ons_update_trigger
      AFTER UPDATE ON add_ons
      FOR EACH ROW
      BEGIN
          UPDATE item_mapping_records
          SET expenses = (
              SELECT SUM(amount)
              FROM add_ons
              WHERE item_mapping_record_id = NEW.item_mapping_record_id
          )
          WHERE id = NEW.item_mapping_record_id;
      END;
      COMMIT;
    SQL

    execute <<-SQL
      CALL on_update_trigger();
    SQL

    execute <<-SQL
      DROP PROCEDURE IF EXISTS on_delete_trigger;
    SQL

    execute <<-SQL
    CREATE PROCEDURE on_delete_trigger()
      BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
        END;

        START TRANSACTION;

        -- Drop the trigger if it exists
        DROP TRIGGER IF EXISTS add_ons_delete_trigger;

      CREATE TRIGGER add_ons_delete_trigger
      AFTER DELETE ON add_ons
      FOR EACH ROW
      BEGIN
          UPDATE item_mapping_records
          SET expenses = (
              SELECT SUM(amount)
              FROM add_ons
              WHERE item_mapping_record_id = OLD.item_mapping_record_id
          )
          WHERE id = OLD.item_mapping_record_id;
      END;
      COMMIT;
    SQL

    execute <<-SQL
      CALL on_delete_trigger();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS add_ons_insert_trigger;
    SQL

    execute <<-SQL
      DROP TRIGGER IF EXISTS add_ons_update_trigger;
    SQL

    execute <<-SQL
      DROP TRIGGER IF EXISTS add_ons_delete_trigger;
    SQL
  end
end
