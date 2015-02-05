optoro\_skel Cookbook
========================
This cookbook is a skeleton.

Information on our workflow is available at [here](https://optoro.atlassian.net/wiki/display/DO/Adding+a+cookbook+to+the+Chef+Pipeline)

In order to run guard thta will monitor and test your cookbook against chefspec, rubocop and foodcritic first run bundle install,
and then run bundle exec guard in a separate console 

knife-solo is used to create test databags for use with serverspec:
```
  cd test/integration
  bundle exec knife solo data bag create <data_bag>
  bundle exec knife solo data bag create <data_bag> <data_bag_item>
```
