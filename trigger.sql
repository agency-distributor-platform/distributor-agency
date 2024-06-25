DELIMITER $$

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
END$$

DELIMITER ;





DELIMITER $$

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
END$$

DELIMITER ;



DELIMITER $$

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
END$$

DELIMITER ;
