require 'osx/cocoa'
require 'pry'
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
  sleep 4
  new_path = path.gsub("pages", "pdf")
  `mv /Users/Shared/CUPS-PDF/jberlinsky/job_*.pdf #{escape(new_path)}`
  document.closeSaving_savingIn(3, '')
  puts "Processed #{escape file_name} -> #{escape(new_path)}"
end
