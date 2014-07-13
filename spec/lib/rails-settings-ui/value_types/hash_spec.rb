require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Hash do
  describe "#cast" do
    it "should cast string to hash" do
      param = "{\"border_color\"=>\"e0e0e0\", \"block_color\"=>\"ffffff\", \"title\"=>{\"font\"=>\"Tahoma\", \"size\"=>\"12\", \"color\"=>\"107821\"}}"
      fixnum_type = RailsSettingsUi::ValueTypes::Hash.new(param)
      expect(fixnum_type.cast).to eq({
        "border_color" => "e0e0e0",
        "block_color" => "ffffff",
        "title" => {
          "font" => "Tahoma",
          "size" => "12",
          "color" => "107821"
        }
      })
    end
  end

  describe "if value not valid hash" do
    it "should be not valid" do
      fixnum_type = RailsSettingsUi::ValueTypes::Hash.new("{\"border_color\"=>, \"block_color\"=>\"ffffff\"")
      expect(fixnum_type.valid?).to be_falsey
    end
  end
end