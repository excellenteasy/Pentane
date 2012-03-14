#! /bin/bash
for file in examples/*; do    
	if [ -d $file ]; then       
		sudo cp /Applications/example.app/Contents/Resources/Scripts/main.scpt $file/Contents/Resources/Scripts/main.scpt;
	fi; 
done
