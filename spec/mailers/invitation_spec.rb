RSpec.describe InvitationMailer do
  let(:invitation) { build_stubbed(:invitation) }

  describe "new_user" do
    let(:mail) do 
      InvitationMailer.new_user(invitation)
    end

    it "renders the headers" do
      expect(mail.subject).to match(/you are invited/i)
      expect(mail.to).to eq([invitation.recipient_email])
    end

    it "renders the body" do
      aggregate_failures do
        mail.parts.each do |part|
          expect(part.encoded).to match(/you have been invited/i), "could not find a match in the #{part.content_type} email part"
        end
      end
    end
  end

  describe "existing_user" do
    let(:mail) do 
      InvitationMailer.existing_user(invitation)
    end

    it "renders the headers" do
      expect(mail.subject).to match(/You are invited/i)
      expect(mail.to).to eq([invitation.recipient_email])
    end

    it "renders the body" do
      aggregate_failures do
        mail.parts.each do |part|
          expect(part.encoded).to match(/you have been added/i), "could not find a match in the #{part.content_type} email part"
        end
      end
    end
  end
end