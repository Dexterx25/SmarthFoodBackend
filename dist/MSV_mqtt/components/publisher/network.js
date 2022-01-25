"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
/* eslint-disable prefer-const */
const mqtt_1 = __importDefault(require("mqtt"));
const index_1 = require("../../../configurations/index");
const clientId = `mqtt_JuanDavidBlancoVergara`;
const connectUrl = `mqtt://${index_1.config.mqtt_config.host}:${index_1.config.mqtt_config.port}`;
console.log('MQTT URL--->', connectUrl);
const pubClient = mqtt_1.default.connect(connectUrl, {
    clientId
});
exports.default = pubClient;
//# sourceMappingURL=network.js.map