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

echo "<h3>Target Servers</h3>" >> "$report_html"

mkdir -p "$export_folder/$organization/config/resources/edge/env/$environment/target-servers"

sackmesser list "organizations/$organization/environments/$environment/targetservers"| jq -r -c '.[]|.' | while read -r tsname; do
        sackmesser list "organizations/$organization/environments/$environment/targetservers/$tsname" > "$export_folder/$organization/config/resources/edge/env/$environment/target-servers/$tsname".json
        elem_count=$(jq '.entries? | length' "$export_folder/$organization/config/resources/edge/env/$environment/target-servers/$tsname".json)
    done

if ls "$export_folder/$organization/config/resources/edge/env/$environment/target-servers"/*.json 1> /dev/null 2>&1; then
    jq -n '[inputs]' "$export_folder/$organization/config/resources/edge/env/$environment/target-servers"/*.json > "$export_folder/$organization/config/resources/edge/env/$environment/target-servers".json
fi

echo "<div><table id=\"ts-lint\" data-toggle=\"table\" class=\"table\">" >> "$report_html"
echo "<thead class=\"thead-dark\"><tr>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"id\">Name</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"host\">Host</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"port\">Port</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"enabled\">isEnabled</th>" >> "$report_html"
echo "</tr></thead>" >> "$report_html"

echo "<tbody class=\"mdc-data-table__content\">" >> "$report_html"

jq -c '.[]' "$export_folder/$organization/config/resources/edge/env/$environment/target-servers".json | while read i; do 
    tsName=$(echo "$i" | jq -r '.name')
    _enabled=$(echo "$i" | jq -r '.isEnabled')
    host=$(echo "$i" | jq -r '.host')
    port=$(echo "$i" | jq -r '.port')

    if [ $_enabled = true ]
        then
            isEnabled="✅"
        else
            isEnabled="❌"
    fi

    echo "<tr class=\"$highlightclass\">"  >> "$report_html"
    echo "<td>$tsName</td>"  >> "$report_html"
    echo "<td>"$host"</td>"  >> "$report_html"
    echo "<td>$port</td>" >> "$report_html"
    echo "<td>$isEnabled</td>" >> "$report_html"
    echo "</tr>"  >> "$report_html"
done

echo "</tbody></table></div>" >> "$report_html"
