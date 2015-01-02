# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ImageQuant'
  app.version = '0.1'
  app.deployment_target = '10.8'
  app.codesign_for_release = false
  app.info_plist['NSMainNibFile'] = 'MainMenu'
end

desc "Install pngquant into Resources directory"
task :pngquant do
  sh "curl -O http://pngquant.org/pngquant.tar.bz2"
  sh "tar xvzf pngquant.tar.bz2"
  sh "mv pngquant resources/"
  sh "rm pngquant* COPYRIGHT"
end

namespace :archive do
  desc "Create a .dmg archive"
  task :dmg do
    Rake::Task['build:release'].invoke

    config = Motion::Project::App.config
    dmg_name = "#{config.name}_#{config.version}"

    sh "rm -rf build/Release"
    sh "rm -f build/#{dmg_name}.dmg"
    sh "rsync -a build/MacOSX-#{config.deployment_target}-Release/#{config.name}.app build/Release"
    sh "ln -sf /Applications build/Release"

    sh "hdiutil create build/tmp.dmg -volname #{dmg_name} -srcfolder build/Release"
    sh "hdiutil convert -format UDBZ build/tmp.dmg -o build/#{dmg_name}.dmg"
    sh "rm -f build/tmp.dmg"
  end
end
