// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JobMarketplaceContract {
    //Defining Data Structures -------------------------------------------------
    struct JobOffer {
        uint id;
        string title;
        string description;
        address freelancer;
        address client;
        uint paymentAmount;
        uint status; // 0: created, 1: accepted, 2: completed, 3: disputed
    }

    struct Payment {
        uint amount;
        uint status; // 0: created, 1: released, 2: disputed
        address client;
        address freelancer;
    }

    //events -------------------------------------------------------------------

    event jobOfferCreated(
        uint indexed id,
        string title,
        string description,
        address freelancer,
        uint paymentAmount
    );

    //Defining variables -------------------------------------------------------
    JobOffer[] public jobOffers;

    //Defining functions -------------------------------------------------------

    //The freelancer will create a job offer
    function createJobOffer(
        string memory _title,
        string memory _description,
        uint _paymentAmount
    ) public {
        /* ALTERNATIVE WAY TO MAKE IT: JobOffer memory newJobOffer = JobOffer({
            id: jobOffers.length,
            title: _title,
            description: _description,
            freelancer: msg.sender,
            client: address(0),
            paymentAmount: _paymentAmount,
            status: 0
        }); */
        jobOffers.push(
            JobOffer(
                jobOffers.length,
                _title,
                _description,
                msg.sender,
                address(0),
                _paymentAmount,
                0
            )
        );
        emit jobOfferCreated(
            jobOffers[jobOffers.length - 1].id,
            jobOffers[jobOffers.length - 1].title,
            jobOffers[jobOffers.length - 1].description,
            jobOffers[jobOffers.length - 1].freelancer,
            jobOffers[jobOffers.length - 1].paymentAmount
        );
    }

    //The client will accept a job offer

    function acceptJobOffer(uint _jobOfferId) public payable {
        require(
            msg.sender != jobOffers[_jobOfferId].freelancer,
            "The freelancer cannot accept his own job offer"
        );
        require(
            msg.value == jobOffers[_jobOfferId].paymentAmount,
            "The payment amount must be equal to the job offer payment amount"
        );
        require(
            jobOffers[_jobOfferId].status == 0,
            "The job offer must be in created status"
        );
        jobOffers[_jobOfferId].client = msg.sender;
        jobOffers[_jobOfferId].status = 1;
    }

    //The freelancer will complete a job offer
    function completeJobOffer(uint _jobOfferId) public {
        require(
            msg.sender == jobOffers[_jobOfferId].freelancer,
            "Only the freelancer can complete the job offer"
        );
        require(
            jobOffers[_jobOfferId].status == 1,
            "The job offer must be in accepted status"
        );
        jobOffers[_jobOfferId].status = 2;
    }
}
