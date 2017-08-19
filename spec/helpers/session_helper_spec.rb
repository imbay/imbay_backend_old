require 'rails_helper'

RSpec.describe SessionHelper, type: :helper do
    class Session
        include SessionHelper
    end
    session = Session.new
    it "| redis server is not started." do
        session_name = session.new_session
        expect(session_name.class.name).to eq "String"
        expect(session.set_session_value(session_name, "foo", "bar")).to be true
        expect(session.get_session_value(session_name, "foo")).to eq "bar"
        expect(session.del_session_value(session_name, "foo")).to eq true
        expect(session.delete_session(session_name)).to be true
    end
end
