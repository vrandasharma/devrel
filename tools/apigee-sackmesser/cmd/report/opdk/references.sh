#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# <http://www.apache.org/licenses/LICENSE-2.0>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "<h3>References</h3>" >> "$report_html"

mkdir -p "$export_folder/$organization/config/resources/edge/env/$environment/reference"

sackmesser list "organizations/$organization/environments/$environment/references"| jq -r -c '.[]|.' | while read -r referencename; do
        sackmesser list "organizations/$organization/environments/$environment/references/$referencename" > "$export_folder/$organization/config/resources/edge/env/$environment/reference/$referencename".json
        elem_count=$(jq '.entries? | length' "$export_folder/$organization/config/resources/edge/env/$environment/reference/$referencename".json)
    done

if ls "$export_folder/$organization/config/resources/edge/env/$environment/reference"/*.json 1> /dev/null 2>&1; then
    jq -n '[inputs]' "$export_folder/$organization/config/resources/edge/env/$environment/reference"/*.json > "$export_folder/$organization/config/resources/edge/env/$environment/references".json
fi

echo "<div><table id=\"reference-lint\" data-toggle=\"table\" class=\"table\">" >> "$report_html"
echo "<thead class=\"thead-dark\"><tr>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"id\">Name</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"refers\">Refers</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"restype\">Resource Type</th>" >> "$report_html"
echo "</tr></thead>" >> "$report_html"

echo "<tbody class=\"mdc-data-table__content\">" >> "$report_html"

jq -c '.[]' "$export_folder/$organization/config/resources/edge/env/$environment/references".json | while read i; do 
    referenceName=$(echo "$i" | jq -r '.name')
    refers=$(echo "$i" | jq -r '.refers')
    resourceType=$(echo "$i" | jq -r '.resourceType')
    
    echo "<tr class=\"$highlightclass\">"  >> "$report_html"
    echo "<td>$referenceName</td>"  >> "$report_html"
    echo "<td>$refers</td>" >> "$report_html"
    echo "<td>$resourceType</td>" >> "$report_html"
    echo "</tr>"  >> "$report_html"
done

echo "</tbody></table></div>" >> "$report_html"