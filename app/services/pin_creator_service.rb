#app/services/pin_creator_service.rb
class PinCreatorService
  attr_reader

  def initialize(pin_params, user)
    @params = pin_params
    @surgeon_attributes = @params["surgeon_attributes"]
    @procedure_attributes = @params["procedure_attributes"]
    @user = user
  end

  def create
    if @surgeon_attributes.present?
      @surgeon_attributes.delete('_destroy')
      @surgeon_attributes.delete('id')

      surgeon = Surgeon.new(@surgeon_attributes)
      @params["surgeon_id"] = surgeon.id if surgeon.save
    else
      @params["surgeon_id"] = Surgeon.find_by_last_name(@params["surgeon_id"].split(',').first).id
    end

    if @procedure_attributes.present?
      @procedure_attributes.delete('_destroy')

      procedure = Procedure.new(@procedure_attributes)
      @params["procedure_id"] = procedure.id if procedure.save
    else
      @params["procedure_id"] = Procedure.find_by_name(@params["procedure_id"]).id
    end

    @params.delete("surgeon_attributes")
    @params.delete("procedure_attributes")

    @user.pins.new(@params.symbolize_keys)
  end

end