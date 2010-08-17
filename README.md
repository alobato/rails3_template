rails3_template
===============

	cd ~/projects
	mkdir appname
	cd appname
	rvm gemset create gemsetname
	rvm 1.8.7@gemsetname
	echo "rvm 1.8.7@gemsetname" > .rvmrc

	gem install rails --pre

	# Create new rails application on current directory without test unit (T), without prototype(J) and with mysql database (-d mysql)
	rails new . -JT -d mysql -m ~/projects/rails3_template/main.rb

	compass init rails .	
	rm app/stylesheets/*
