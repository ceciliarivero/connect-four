.PHONY: test

gems:
	which gemset  || gem install gemset
	which dep || gem install dep
	which shotgun || gem install shotgun
	gemset init

console:
	env $$(cat env.sh) irb -r ./app

install:
	dep install

dev:
	dep install -f .gems.dev

seed:
	env $$(cat env.sh) ruby -r ./app.rb db/seed.rb

server:
	env $$(cat env.sh) shotgun -o 0.0.0.0

test:
	env $$(cat env.sh) cutest -r ./test/helper.rb ./test/general/play.rb
