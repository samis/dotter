module Dotter
  class DotterError < StandardError
  end
  class PackageAlreadyStowedError < DotterError
  end
  class PackageNotStowedError < DotterError
  end
  class PackageNotTrackedError < DotterError
  end
end
