namespace :surgeons do
  desc "old surgeons into new surgeons"
  task :surgeon_transfer => :environment do

    surgeons = OldSurgeon.all
    regular_names = []
    surgeons.each {|s| regular_names << s if s.SurgeonName.split.length == 2}

    bar = RakeProgressbar.new(regular_names.count)

    regular_names.each do |u|
      #:surgeonname, :address, :city, :state, :zip, :country, :phone, :email, :url, :procedures, :notes
      #:address, :city, :country, :email, :id, :first_name, :last_name, :phone, :procedures, :state, :url, :zip, :notes

      if Surgeon.where(id: u.id).blank?
        Surgeon.new(id: u.id, email: u.Email, first_name: u.SurgeonName.split(',').last, last_name: u.SurgeonName.split(',').first,
                  phone: u.Phone, url: u.URL, procedure_list: u.Procedures, notes: u.Notes,
                  zip: u.ZIP, city: u.City, country: u.Country, address: u.Address ).save(:validate => false)
      end
      bar.inc
    end

    p (surgeons.count - regular_names.count).to_s + " remaining surgeons with weird names to be coverted."
  end

  desc "old surgeons into new surgeons that have weird names"
  task :weird_names => :environment do

    surgeons = OldSurgeon.all
    weird_names = []
    surgeons.each {|s| weird_names << s if s.SurgeonName.split.length > 2}
    weird_names.each {|s| s.SurgeonName.gsub!(/(dr.|Dr.|dr|Dr|MD|md|M.D.|FRCS)/, '')}

    bar = RakeProgressbar.new(weird_names.count)

    weird_names.each do |u|
      #:surgeonname, :address, :city, :state, :zip, :country, :phone, :email, :url, :procedures, :notes
      #:address, :city, :country, :email, :id, :first_name, :last_name, :phone, :procedures, :state, :url, :zip, :notes

      if Surgeon.where(id: u.id).blank?
        Surgeon.new(id: u.id, email: u.Email, first_name: u.SurgeonName.split(',').last, last_name: u.SurgeonName.split(',').first,
                  phone: u.Phone, url: u.URL, procedure_list: u.Procedures, notes: u.Notes,
                  zip: u.ZIP, city: u.City, country: u.Country, address: u.Address ).save(:validate => false)
      end
      bar.inc
    end

    p weird_names.count.to_s + " weird names converted."
  end

  desc "remove leading white space from surgeon first name"
  task :white_space_removal => :environment do
    surgeons = Surgeon.all
    surgeons.each do |surgeon|
      if surgeon.first_name.present?
        new_name = surgeon.first_name.gsub(/\A\s/, '')
        surgeon.update_attributes(first_name: new_name) unless new_name.blank?
        surgeon.save
      end
    end
  end

  desc "fix outliers"
  task :outliers => :environment do
    medalie_pins = Pin.where(surgeon_id: [934, 1012, 956, 954, 947])
    medalie_pins.each {|p| p.surgeon_id = 12; p.save! }

    mclean_pins = Pin.where(surgeon_id: [960, 1000, 989, 986, 980, 976, 979, 971, 970, 969, 968, 967, 975, 964, 963, 950, 958, 1011])
    mclean_pins.each {|p| p.surgeon_id = 31; p.save! }

    mcguinn_pins = Pin.where(surgeon_id: [994, 973, 961, 1003, 974, 1001, 965, 995])
    mcguinn_pins.each {|p| p.surgeon_id = 18; p.save! }

    vanloen_pins = Pin.where(surgeon_id: [165, 946, 990])
    vanloen_pins.each {|p| p.surgeon.id = 164; p.save!}

    yelland_pins = Pin.where(surgeon_id: [206, 978])
    yelland_pins.each {|p| p.surgeon.id = 207; p.save!}

    jj_pins = Pin.where(surgeon_id: 999)
    jj_pins.each {|p| p.surgeon.id = 170; p.save!}

    morehouse_pins = Pin.where(surgeon_id: 952)
    morehouse_pins.each {|p| p.surgeon.id = 167; p.save!}

  end
end