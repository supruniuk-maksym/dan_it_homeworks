const winston = require('winston');
const fluent = require('fluent-logger');


fluent.configure('nodejs-app', {
  host: 'fluentd',
  port: 24224,
  timeout: 3.0,
  requireAckResponse: true
});


class FluentTransport extends winston.Transport {
  log(info, callback) {
    setImmediate(() => this.emit('logged', info));
    fluent.emit('log', info);
    callback();
  }
}


const logger = winston.createLogger({
  level: 'info',
  transports: [
    new FluentTransport(),
    new winston.transports.Console()
  ]
});

module.exports = logger;



















































