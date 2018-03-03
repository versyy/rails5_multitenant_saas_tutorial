group :rails, halt_on_fail: true do
  guard :rspec, all_on_start: true, cmd: 'spring rspec' do
    watch(%r{^spec/(.+)_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.erb$})      { |m| "spec/#{m[1]}.erb_spec.rb" }
  end

  guard :rubocop, all_on_start: true, cli: ['--display-cop-names'] do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})
    watch(%r{^app/(.+)\.rb$})
  end
end
