/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* eslint-disable no-invalid-this */ // See usage in apickli Documentation
/* eslint-disable new-cap */
"use strict";

const apickliModule = require("apickli");
const { Before, setDefaultTimeout } = require("@cucumber/cucumber");

setDefaultTimeout(5 * 1000); // this is in ms

Before(function () {
  const host = process.env.TEST_HOST || "34.131.144.184.nip.io";
  const basePath = process.env.API_BASE_PATH || `/test`;
  const port = process.env.TEST_HOST_PORT || `443`;
  const baseUri = `${host}:${port}${basePath}`;
  console.log(`Test Base URI: ${baseUri}`);
  this.apickli = new apickliModule.Apickli(process.env.API_PROTOCOL || "https", baseUri);
  this.apickli.addRequestHeader("Cache-Control", "no-cache");
  this.apickli.addRequestHeader("Authorization", "Basic YWRtaW46c2VjcmV0");
});