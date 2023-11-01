xml_directory=".."

declare -A id_map

for file in "$xml_directory"/Warhammer\ 40\,000.gst; do
#for file in "$xml_directory"/*.{gst,cat}; do
	echo $file
	if [ -f "$file" ]; then
		ids=($(grep -oiE "id=\"[^\"]*\"|Id=\"[^\"]*\"" "$file"))
		for id in "${ids[@]}"; do
		    echo "OLD: "$id

		    id_lower=$(echo "$id" | tr '[:upper:]' '[:lower:]')
		    if [[ -z "${id_map[$id_lower]}" ]]; then
                        new_uuid=$(uuidgen)
                        id_map["$id_lower"]=$new_uuid
                    else
                        new_uuid="${id_map[$id_lower]}"
                    fi

	    	    echo "NEW: "$new_uuid

		    if [[ $id == "id=\""* ]]; then
			sed -i "s/$id/id=\"$new_uuid\"/g" "$file"
		    else
			sed -i "s/$id/Id=\"$new_uuid\"/g" "$file"
		    fi		
	    done
	fi
done

echo "All ID tags replaced with new UUIDs in XML files."
