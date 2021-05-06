# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe GDK::Backup do
  let(:gdk_root_dir) { '/home/git/gdk' }
  let(:gdk_root_path) { Pathname.new(gdk_root_dir) }

  let(:backups_path_only) { '.backups' }
  let(:backups_path) { gdk_root_path.join('.backups') }

  let!(:now) { DateTime.parse('2021-05-06 18:50:31.279931 +1000').to_time }

  before do
    allow(GDK).to receive(:root).and_return(gdk_root_path)
  end

  describe 'initialize' do
    context 'when the source file is outside of the GDK' do
      it 'raises an exception' do
        expect { described_class.new(Tempfile.new.path) }.to raise_error(GDK::Backup::SourceFileOutsideOfGdk)
      end
    end

    context 'when the source file does not exist' do
      it 'raises an exception' do
        fake_source_file = gdk_root_path.join('tmp/filethatdoesntexist.txt')

        expect { described_class.new(fake_source_file) }.to raise_error(Errno::ENOENT)
      end
    end

    context 'when the source file does exist' do
      it 'does not raise an exception' do
        fake_source_file = gdk_root_path.join('Procfile')
        stub_source_file(fake_source_file)

        expect(described_class.new(fake_source_file)).to be_instance_of(described_class)
      end
    end
  end

  describe '.root' do
    it 'is /Users/ash/src/gitlab/gitlab-development-kit/.backups' do
      fake_root_pathname = stub_root

      expect(described_class.root).to be(fake_root_pathname)
    end
  end

  describe '#destination_file' do
    it 'returns a fully qualified Pathname to the backup destination file' do
      fake_source_file = gdk_root_path.join('Procfile')
      stub_source_file(fake_source_file)

      stub_root

      travel_to(now) do
        fake_destination_file = backups_path.join('Procfile.20210506185031')

        expect(described_class.new(fake_source_file).destination_file.to_s).to eq(fake_destination_file.to_s)
      end
    end
  end

  describe '#backup!' do
    shared_examples 'a file to be backed up' do |fake_source_file, fake_destination_file|
      it 'and makes a backup' do
        fake_source_file_full = gdk_root_path.join(fake_source_file)
        stub_source_file(fake_source_file_full)

        fake_root_pathname = stub_root

        allow(fake_root_pathname).to receive(:mkpath).and_return(true)

        travel_to(now) do
          fake_destination_file_full = File.join(gdk_root_dir, fake_destination_file)

          expect(FileUtils).to receive(:cp).with(fake_source_file_full.to_s, fake_destination_file_full.to_s).and_return(true)
          expect(GDK::Output).to receive(:info).with("A backup of '#{fake_source_file}' has been made at '#{fake_destination_file}'.")

          expect(described_class.new(fake_source_file_full).backup!).to be(true)
        end
      end
    end

    context 'is a file only' do
      it_behaves_like 'a file to be backed up', 'Procfile', '.backups/Procfile.20210506185031'
    end

    context 'is a file within a directory' do
      it_behaves_like 'a file to be backed up', 'gitlab/config/gitlab.yml', '.backups/gitlab__config__gitlab.yml.20210506185031'
    end
  end

  def stub_root
    fake_root_pathname = Pathname.new(gdk_root_dir).join(backups_path_only)

    allow(gdk_root_path).to receive(:join).with('.backups').and_return(fake_root_pathname)
    allow(fake_root_pathname).to receive(:realpath).and_return(fake_root_pathname)

    fake_root_pathname
  end

  def stub_source_file(file)
    file = file.to_s
    fake_source_file_pathname = Pathname.new(file)

    allow(Pathname).to receive(:new).and_call_original
    allow(Pathname).to receive(:new).with(file).and_return(fake_source_file_pathname)
    allow(fake_source_file_pathname).to receive(:realpath).and_return(fake_source_file_pathname)

    fake_source_file_pathname
  end

  def fake_destination_file_from(source_file, now)
    treated_source_file = source_file.to_s.gsub('/', '__')
    fake_file_only = "#{treated_source_file}.#{now.strftime('%Y%m%d%H%M%S')}"
    backups_path.join(fake_file_only).to_s
  end
end
