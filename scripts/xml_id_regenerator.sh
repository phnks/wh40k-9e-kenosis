xml_directory=".."

declare -A id_map

#for file in "$xml_directory"/Warhammer\ 40\,000.gst; do
for file in "$xml_directory"/*.{gst,cat}; do
	echo $file
	if [ -f "$file" ]; then
		ids=($(grep -o "id=\"[^\"]*\"" "$file" | sed 's/id="//' | sed 's/"//'))
		for id in "${ids[@]}"; do
			echo "OLD: "$id
			if [[ -z "${id_map[$id]}" ]]; then
				new_uuid=$(uuidgen)
				id_map["$id"]=$new_uuid
			else
				new_uuid="${id_map[$id]}"
			fi
			echo "NEW: "$new_uuid

		        sed -i "s/id=\"$id\"/id=\"$new_uuid\"/g" "$file"
		done
	fi
done

echo "All ID tags replaced with new UUIDs in XML files."
