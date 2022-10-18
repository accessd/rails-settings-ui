class Settings < RailsSettings::Base
  cache_prefix { "v1" }

  field :project_name, type: :string, default: "Dummy"
  scope :limits do
    field :limit, type: :integer, default: 150
  end
  field :angle, type: :float, default: 0.5
  field :style, type: :hash, default: {
    border_color: 'e0e0e0',
    block_color: 'ffffff',
    title: {
      font: "Tahoma",
      size: "12",
      color: '107821'
    }
  }
  field :check_something, type: :boolean, default: true
  field :description, type: :string,
    default: "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful."
  field :mode, type: :array, default: [:auto, :manual]
  field :timer, default: 2.hours
  field :project_status, default: :finished
  field :locale, default: [:en, :ru]
  field :readonly_item, type: :integer, default: 100, readonly: true
end
