/**
 * Project : iot-home
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 08/04/2018
 * Copyright :  S.Hamblett
 *
 * Triggered from a sensor date message on the iot-home
 * Cloud Pub/Sub topic.
 *
 * @param {!Object} event The Cloud Functions event.
 * @param {!Function} The callback function.
 *
 * Writes the incoming sensor data to the deatination BigQuery table
 * and logs the incoming data and the result of the update.
 */

// Get a reference to the BigQuery component
const bigquery = require('@google-cloud/bigquery')();

/**
 * Helper method to get a handle on our BigQuery table.
 */
function getTable () {
  const dataset = bigquery.dataset("iot_home");

  return dataset.get()
    .then(([dataset]) => dataset.table("sensor_data").get());
}

exports.subscribe = (event, callback) => {
  // The Cloud Pub/Sub Message object.
  const pubsubMessage = event.data;

  // Log the incoming sensor data and ack the topic.
  var sensorDataString = Buffer.from(pubsubMessage.data, 'base64').toString();
  console.log(sensorDataString);
  callback();

  // Construct the update parameters
  var parameters = sensorDataString.split(":");
  var itype = parameters[0];
  var ivalue = parseInt(parameters[1]);
  var itimestamp = parseInt(parameters[2]) / 1000;
  var insertRow = [{type: itype, value: ivalue, at: itimestamp}];
  // Insert into BigQuery
  getTable().then(([table]) => {
    table.insert(insertRow)
    .then(() => {
      console.log(`Inserted 1 row`)
    });
  });
};
