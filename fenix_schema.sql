CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--   "exec": "concurrently \"ts-node ./src/api/index.ts\"  \"ts-node ./src/MSV_mqtt/mqtt.ts\"  \" ts-node ./src/msv_chats/chats.ts \" "
  

