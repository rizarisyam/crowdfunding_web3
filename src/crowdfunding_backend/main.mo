import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import WhoAmI "WhoAmI";
import D "mo:base/Debug";

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
    name : Text;
    goal : Nat;
    balance : Nat;
    deadline : Int;
    owner: Text;
    description : Text;
    isNotFinished : Bool;
  };

  let campaigns = Buffer.Buffer<Campaign>(10);

  var raised: Nat = DEFAULT_RAISED;

  private func isTextEmpty(text: Text): Bool {
    return Text.size(text) == 0
  };

// 
  public shared ({caller}) func createCampaign(payload: PayloadCreateCampaign) : async Nat {
    if (isTextEmpty(payload.name) or isTextEmpty(payload.description) or payload.goal == 0 or payload.deadline <= 0) {
      // Input validation failed
      return 0;
    };
    D.print("Caller is: " # debug_show caller);

    let raisedTotal: Nat = 0;

    for (campaign in campaigns.vals()) {
      raised += campaign.raised;
    };

    let campaign : Campaign = {
      id = campaigns.size() + 1;
      name = payload.name;
      goal = payload.goal;
      balance = payload.balance;
      owner = payload.owner;
      donationsCount = campaigns.size();
      deadline = payload.deadline;
      description = payload.description;
      isNotFinished = true;
      imageURL = DEFAULT_IMAGE_URL;
      raised = raised;
    };

    campaigns.add(campaign);
    return campaign.id;
  };

  public query func getCampaigns() : async [Campaign] {
    return Buffer.toArray<Campaign>(campaigns);
  };

  public query func getCampaign(index: Nat) : async Campaign {
    if (index < 0 or index >= campaigns.size()) {
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
    };
    return campaigns.get(index);
    
  };


  public query func endOfCampaign(index: Nat, value: Bool): async Campaign {
    if (index < 0 or index >= campaigns.size()) {
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
    };

    let campaign = campaigns.get(index);
    let campaignModified : Campaign = {
      id = campaign.id;
      name = campaign.name;
      goal = campaign.goal;
      balance = campaign.balance;
      owner = campaign.owner;
      donationsCount = campaign.donationsCount;
      deadline = campaign.deadline;
      description = campaign.description;
      isNotFinished = value;
      imageURL = DEFAULT_IMAGE_URL;
      raised = campaign.raised;
    };
    campaigns.put(index, campaignModified);
    
    return campaigns.get(index);
  }

};
