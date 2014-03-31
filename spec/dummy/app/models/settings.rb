class Settings < RailsSettings::CachedSettings
  defaults[:project_name] = "Dummy"
  defaults[:limit] = 150
  defaults[:style] = {
    border_color: 'e0e0e0',
    block_color: 'ffffff',
    title: {
      font: "Tahoma",
      size: "12",
      color: '107821'
    }
  }
  defaults[:check_something] = true
  defaults[:description] = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful."
  defaults[:mode] = [:auto, :manual]
end
