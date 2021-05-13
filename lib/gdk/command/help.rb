# frozen_string_literal: true

require 'fileutils'

module GDK
  module Command
    class Help < BaseCommand
      def run(args = [])
        GDK::Logo.print
        stdout.puts File.read(GDK.root.join('HELP'))

        true
      end
    end
  end
end
