require 'spec_helper'

describe RailsSettingsUi::SettingsFormCoercible do

  describe "#coerce!" do
    context 'integer' do
      it do
        expect(coerce('limit' => '123')).to eq(123)
      end
    end

    context 'float' do
      it do
        expect(coerce('angle' => '45.5')).to eq(45.5)
        expect(coerce('angle' => '45')).to eq(45.0)
      end
    end

    context 'string' do
      it do
        expect(coerce('project_name' => 'rsu')).to eq('rsu')
      end
    end

    context 'symbol' do
      it do
        expect(coerce('project_status' => 'pending')).to eq(:pending)
      end
    end

    context 'ActiveSupport::Duration' do
      it do
        expect(coerce('timer' => '600')).to eq(600)
        expect(coerce('timer' => '600.5')).to eq(600)
      end
    end

    context 'hash' do
      it do
        expect(coerce('style' => JSON.generate(sample_hash))).to eq(sample_hash)
      end
    end

    context 'array' do
      it 'hash as array of keys as symbols' do
        expect(coerce('mode' => {auto: "on", manual: "on"})).to eq([:auto, :manual])
        expect(coerce('mode' => {})).to eq([])
      end

      it "if setting presented as select should coerce selected value as symbol" do
        expect(coerce('mode' => "auto")).to eq(:auto)
      end

      it "should accept ActionController::Parameters" do
        param = ActionController::Parameters.new('auto' => 'on', 'manual'=> 'off')
        expect(coerce('mode' => param)).to eq([:auto])
      end
    end

    context 'boolean' do
      it 'true' do
        expect(coerce('check_something' => 'on')).to eq(true)
        expect(coerce('check_something' => 'true')).to eq(true)
      end

      it 'false' do
        expect(coerce('check_something' => 'off')).to eq(false)
        expect(coerce('check_something' => 'false')).to eq(false)
      end
    end

    describe 'not coercible' do
      it 'raise exception' do
        Settings.defaults[:project_name] = nil
        expect do
          coerce('project_name' => 'rsu')
        end.to raise_error(RailsSettingsUi::NotCoercibleError)
        Settings.defaults[:project_name] = "Dummy"
      end
    end

    describe 'if setting not passed and default value type' do
      it 'is boolean then should have to set value to false' do
        Settings.defaults[:check_something] = true
        expect(build_coercion({}).coerce![:check_something]).to eq(false)
      end

      it 'is array then should have to set value to empty array' do
        Settings.defaults[:check_something] = [:auto, :manual]
        expect(build_coercion({}).coerce![:mode]).to eq([])
        Settings.defaults[:check_something] = true
      end
    end

  end

  begin 'Helper methods'

    def coerce(settings)
      @coerced_settings = build_coercion(settings_form.merge(settings)).coerce!
      return @coerced_settings unless settings.keys.first
      @coerced_settings[settings.keys.first.to_sym]
    end

    def build_coercion(settings)
      validator = described_class.new(
        Settings.defaults,
        settings
      )
    end

    def settings_form
      {
        'limit' => '123',
        'angle' => '0.5',
        'project_name' => 'qwe',
        'check_something' => 'on',
        'style' => JSON.generate(sample_hash),
        'timer' => '1800',
        'mode' => {auto: "on", manual: "on"},
        'project_status' => 'in_process'
      }
    end

    def sample_hash
      {
        "border_color" => "e0e0e0",
        "block_color" => "ffffff",
        "title" => {
          "font" => "Tahoma",
          "size" => "12",
          "color" => "107821"
        }
      }
    end

  end

end
