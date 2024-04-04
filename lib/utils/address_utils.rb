module Utils
  class AddressUtils
    def self.is_false_pincode?(pincode)
      pincode = pincode.to_i
      (pincode.zero? || pincode < 100000 || pincode > 999999)
    end

    def self.is_false_state_or_ut?(state_ut)
      states_and_uts = [
        "Andhra Pradesh",
        "Arunachal Pradesh",
        "Assam",
        "Bihar",
        "Chhattisgarh",
        "Goa",
        "Gujarat",
        "Haryana",
        "Himachal Pradesh",
        "Jharkhand",
        "Karnataka",
        "Kerala",
        "Maharashtra",
        "Madhya Pradesh",
        "Manipur",
        "Meghalaya",
        "Mizoram",
        "Nagaland",
        "Odisha",
        "Punjab",
        "Rajasthan",
        "Sikkim",
        "Tamil Nadu",
        "Tripura",
        "Telangana",
        "Uttar Pradesh",
        "Uttarakhand",
        "West Bengal",
        "Andaman & Nicobar",
        "Chandigarh",
        "Dadra & Nagar Haveli",
        "Daman & Diu",
        "Delhi",
        "Jammu & Kashmir",
        "Ladakh",
        "Lakshadweep",
        "Puducherry"
      ]
      !states_and_uts.include?(state_ut.titleize)
    end
  end
end
