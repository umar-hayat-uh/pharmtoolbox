class Tools::DosageCalculatorController < ApplicationController
  def index
  end

  def calculate_solid
    weight = params[:weight].to_i
    dosage_per_kg = params[:dosage_per_kg].to_i
    tablet_strength = params[:tablet_strength].to_i
    frequency = params[:frequency]

    freq_map = {
      "Once/day" => 1,
      "Twice/day" => 2,
      "Three times/day" => 3,
      "Four times/day" => 4
    }

    total_daily_dose = weight * dosage_per_kg
    single_dose = total_daily_dose / freq_map[frequency]
    tablets_needed = (single_dose.to_f / tablet_strength).ceil # round up to whole tablet

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "solid_result",
          partial: "tools/dosage_calculator/solid_result",
          locals: {
            total_daily_dose: total_daily_dose,
            single_dose: single_dose,
            tablets_needed: tablets_needed
          }
        )
      end
    end
  end

  def calculate_liquid
    dosage_mg = params[:dosage_mg].to_i
    concentration = params[:concentration].to_i

    calculated_dose = dosage_mg * concentration

    respond_to do |f|
      f.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "liquid_result",
          partial: "tools/dosage_calculator/liquid_result",
          locals: { calculated_dose: calculated_dose }
        )
      end
    end
  end
end
