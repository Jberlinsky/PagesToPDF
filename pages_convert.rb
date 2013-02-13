require 'osx/cocoa'
require 'pry'
require 'fileutils'
include OSX
OSX.require_framework 'ScriptingBridge'

`rm -rf /Users/Shared/CUPS-PDF/jberlinsky/*`

def escape(path)
  path.gsub(" ", '\ ')
end

pages = SBApplication.applicationWithBundleIdentifier_("com.apple.iWork.Pages")

files = Dir["/Volumes/Share/Client_List/**/*.pages"]
puts "Converting #{files.count} files..."

files.each do |path|
  file_name = path.split("/").last.split(".").first
  document = pages.open(path)
  pages.print_printDialog_withProperties(path, false, {})
  unless ENV['SKIP_MOVE']
    sleep 4
    new_path = "#{path[0..-5]}.pdf"
    files = Dir['/Users/Shared/CUPS-PDF/jberlinsky/*.pdf']
    FileUtils.move(files, escape(new_path))
    document.closeSaving_savingIn(3, '')
  end
  puts "Processed #{escape file_name}"
end
