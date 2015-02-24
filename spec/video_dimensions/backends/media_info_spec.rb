require 'spec_helper'

module VideoDimensions::Backends
  describe MediaInfo do
    describe '.available?' do
      it 'returns true when utility is available' do
        described_class.stubs(:binary).returns('whoami')
        expect(described_class).to be_available
      end

      it 'returns false when utility is not available' do
        described_class.stubs(:binary).returns('invalidbinary')
        expect(described_class).not_to be_available
      end
    end

    describe 'attribute methods' do
      context '720p sample' do
        let(:sample) { MediaInfo.new(fixture('720p.wmv')) }

        it 'returns the correct dimensions' do
          expect(sample.dimensions).to eq [1280, 720]
        end

        it 'returns the correct width' do
          expect(sample.width).to eq 1280
        end

        it 'returns the correct height' do
          expect(sample.height).to eq 720
        end

        it 'returns the correct bitrate' do
          expect(sample.bitrate).to eq 5904
        end

        it 'returns the correct codec' do
          expect(sample.codec).to eq 'WMV3'
        end

        it 'returns the correct duration' do
          expect(sample.duration).to eq '00:00:02'
        end

        # FIXME: MediaInfo mistakenly reports 1,000 fps?
        # it 'returns the correct framerate' do
        #   expect(sample.framerate).to eq 21.83
        # end
      end

      context '1080p sample' do
        let(:sample) { MediaInfo.new(fixture('1080p.wmv')) }

        it 'returns the correct dimensions' do
          expect(sample.dimensions).to eq [1440, 1080]
        end

        it 'returns the correct width' do
          expect(sample.width).to eq 1440
        end

        it 'returns the correct height' do
          expect(sample.height).to eq 1080
        end

        it 'returns the correct bitrate' do
          expect(sample.bitrate).to eq 9330
        end

        it 'returns the correct codec' do
          expect(sample.codec).to eq 'WMV3'
        end

        it 'returns the correct duration' do
          expect(sample.duration).to eq '00:00:02'
        end

        # FIXME: MediaInfo mistakenly reports 1,000 fps?
        # it 'returns the correct framerate' do
        #   expect(sample.framerate).to eq 21.83
        # end
      end

      context '60 fps sample' do
        let(:sample) { MediaInfo.new('') }

        before do
          sample.stubs(:output).returns(
            """
            Video
            ID                                       : 1
            Format                                   : AVC
            Format/Info                              : Advanced Video Codec
            Format profile                           : High@L3.2
            Format settings, CABAC                   : No
            Format settings, ReFrames                : 4 frames
            Codec ID                                 : V_MPEG4/ISO/AVC
            Duration                                 : 10mn 14s
            Width                                    : 1 280 pixels
            Height                                   : 720 pixels
            Display aspect ratio                     : 16:9
            Frame rate mode                          : Constant
            Frame rate                               : 60.000 fps
            Color space                              : YUV
            Chroma subsampling                       : 4:2:0
            Bit depth                                : 8 bits
            Scan type                                : Progressive
            Writing library                          : x264 core 104 r1703 cd21d05
            """.unindent)
        end

        it 'returns the correct framerate' do
          expect(sample.framerate).to eq 60.00
        end
      end

      context 'duration of at least 1 hour' do
        let(:sample) { MediaInfo.new('') }

        before do
          sample.stubs(:output).returns(
            """
            General
            Complete name                            : video.mp4
            Format                                   : MPEG-4
            Format profile                           : Base Media / Version 2
            Codec ID                                 : mp42
            File size                                : 984 MiB
            Duration                                 : 1h 32mn
            Overall bit rate mode                    : Variable
            Overall bit rate                         : 1 492 Kbps
            Encoded date                             : UTC 2012-07-08 03:49:06
            Tagged date                              : UTC 2012-07-08 04:11:57
            Writing application                      : HandBrake 0.9.6 2012022800
            """.unindent)
        end

        it 'returns the correct duration' do
          expect(sample.duration).to eq '01:32:00'
        end
      end

      context 'duration of at least 1 minute' do
        let(:sample) { MediaInfo.new('') }

        before do
          sample.stubs(:output).returns(
            """
            General
            Complete name                            : video.mp4
            Format                                   : MPEG-4
            Format profile                           : Base Media
            Codec ID                                 : isom
            File size                                : 11.3 MiB
            Duration                                 : 4mn 10s
            Overall bit rate mode                    : Variable
            Overall bit rate                         : 379 Kbps
            Encoded date                             : UTC 2012-01-05 07:04:29
            Tagged date                              : UTC 2012-01-05 07:04:29
            """.unindent)
        end

        it 'returns the correct duration' do
          expect(sample.duration).to eq '00:04:10'
        end
      end
    end
  end
end
