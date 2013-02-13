require 'osx/cocoa'
require 'pry'
include OSX
OSX.require_framework 'ScriptingBridge'

`rm -rf /Users/Shared/CUPS-PDF/jberlinsky/*`

pages = SBApplication.applicationWithBundleIdentifier_("com.apple.iWork.Pages")

files = Dir["/Volumes/Share/Client_List/**/*.pages"]

files.each do |path|
  file_name = path.split("/").last.split(".").first
  document = pages.open(path)
  pages.print_printDialog_withProperties(path, false, {})
  sleep 4
  new_path = path.gsub("pages", "pdf")
  `mv /Users/Shared/CUPS-PDF/jberlinsky/job_*.pdf #{new_path}`
  document.closeSaving_savingIn(3, '')
end
