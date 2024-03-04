import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import WhoAmI "WhoAmI";

actor {

  // Return the principal identifier of the wallet canister that installed this
  // canister.
  public shared (install) func installer() : async Principal {
    return install.caller;
  };

  // Return the principal identifier that was provided as an installation
  // argument to this canister.
  public query func argument(someone : Principal) : async Principal {
    return someone;
  };

  // Return the principal identifier of the caller of this method.
  public shared query (msg) func whoami() : async Principal {
    return msg.caller;
  };

  // Return the principal identifier of this canister.
  public func id() : async Principal {
    return await whoami();
  };

  type Campaign = {
    id : Nat;
    name : Text;
    goal : Nat;
    balance : Nat;
    owner : Text;
    donationsCount : Nat;
    deadline : Int;
    description : Text;
    isNotFinished : Bool;
    imageURL : Text;
    raised : Nat;
  };

  type Donation = {
    amount : Nat;
    donor : Nat;
  };

  type Transaction = {
    amount : Nat;
    recipient : Nat;
    description : Text;
  };

  // Define constants
  let DEFAULT_IMAGE_URL = "default_image_url";
  let DEFAULT_BALANCE = 0;
  let DEFAULT_DONATIONS_COUNT = 0;
  let DEFAULT_RAISED = 0;

  private type PayloadCreateCampaign = {
    owner: Text;
    name: Text;
    description: Text;
    goal: Nat;
    deadline: Int;
  };

  let campaigns = Buffer.Buffer<Campaign>(10);

  public shared ({caller}) func createCampaign(payload: PayloadCreateCampaign) : async Nat {
    if (Text.isEmpty(payload.name) || Text.isEmpty(payload.description) || payload.goal == 0 || payload.deadline <= 0) {
      // Input validation failed
      return 0;
    }

    let campaign : Campaign = {
      id = campaigns.size() + 1;
      name = payload.name;
      goal = payload.goal;
      balance = DEFAULT_BALANCE;
      owner = payload.owner;
      donationsCount = DEFAULT_DONATIONS_COUNT;
      deadline = payload.deadline;
      description = payload.description;
      isNotFinished = true;
      imageURL = DEFAULT_IMAGE_URL;
      raised = DEFAULT_RAISED;
    };

    campaigns.add(campaign);
    return campaign.id;
  };

  public query func getCampaigns() : async [Campaign] {
    return Buffer.toArray<Campaign>(campaigns);
  };

  public query func getCampaign(index : Nat) : async Campaign {
    if (index < 0 || index >= campaigns.size()) {
      // Index out of bounds
      return {
        id = 0;
        name = "Invalid Campaign";
        goal = 0;
        balance = 0;
        owner = "Unknown";
        donationsCount = 0;
        deadline = 0;
        description = "Invalid Campaign";
        isNotFinished = false;
        imageURL = DEFAULT_IMAGE_URL;
        raised = 0;
      };
    }

    return campaigns.get(index);
  };

};
