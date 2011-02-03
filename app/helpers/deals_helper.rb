module DealsHelper
  @@status_images = {
    'new' => '/images/new.gif', 
    'pending' => '/images/pending.gif',
    'due_diligence' => '/images/due_delegence.gif',
    'agreed' => '/images/agreed.gif',
    'rejected' => '/images/rejected.gif'
  }
  
  def round_options
    ['Pre-Seed', 'Seed', 'A', 'B', 'C']
  end
  
  def status_options
    ['new', 'pending', 'due_diligence', 'agreed', 'rejected']
  end
  
  def status_image_for deal
    @@status_images[deal.status]
  end
end
