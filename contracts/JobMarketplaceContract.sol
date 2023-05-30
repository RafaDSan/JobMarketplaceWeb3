// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JobMarketplaceContract {
    struct JobOffer {
        uint id;
        string title;
        string description;
        address freelancer;
        address client;
        uint paymentAmount;
        uint status; // 0: created, 1: accepted, 2: completed, 3: disputed
    }
}
