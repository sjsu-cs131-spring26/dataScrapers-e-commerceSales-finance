Meeting_Notes #1 
# Meeting 1: Stakeholder Alignment
Team: DataScrapers
Date/Time: 2026-03-06 03:00
Duration: 1 hour
Facilitator (PM): Aetius Gular
Notetaker: Bashir Hurani



Stakeholder profile: 
The decision-maker is a Regional Sales Director at an e-commerce company who reports to the VP of Sales. She wants to see in what state to move the marketing money in the US. Since she is not very technical though so, she wants the output to provide a clear number and conclusion based on data,

The decision question is which five states will have priority to get more marketing funds to grow sales and increase revenue.


The success criteria are:
1) To identify and rank the top 10 states by total revenue
2) To identify and flag cancellation and return rates per state to understand potential risks with the operations
3) To provide the sales team with a data-driven recommendation that the director can use without having to review any code.



Scope exclusions:
There will be no product or category analysis since the category and brands have synthetic data that doesn’t look good
There will be no repeat purchase analysis.
There will be no trends.


Open Questions
Question 1: Will the seller concentration be treated as a primary or secondary signal in the recommendation?
Question 2: Will states with little to no orders be flagged differently than other states?


Evidence Plan
File containing Top 10 States by revenue (out1/evidence/top_states_revenue.txt)
File containing order status distribution by state which has the cancellation and return rates (out1/evidence/state_order_status.txt)
File containing seller performance summary which revenue per seller, order count (out1/evidence/seller_performance.txt)


Trust Check
Check for any missing values and  even empty values on the state, orderstatus, totalamount and country columns (out1/evidence/trust_check_missing_values.txt)


Assumption Test
Test for discount field and check for the range value (out1/evidence/assumption_test_discount_range.txt)



Action items
Aetius Gular: Create Sprint Board w/ 10+ Tickets (Due: 2026-03-11)
Aetius Gular: Submit artifacts via pull request for Meeting 1 (Due: 2026-03-11)
Kean Flanagan: Write scripts/run_sprint3.sh entry script with logging and stderr separation (Due: 2026-03-11)
Kean Flanagan: Produce payment_method_breakdown.txt containing Payment Method Counts & Percentages (Due: 2026-03-11)
Kean Flanagan: Produce seller_performance.txt containing the top 20 Sellers by Revenue (Due: 2026-03-11)
Dzhamal Chapanov: Produce top_states_revenue.txt containing the Top 10 U.S. States by Total Amount (Due: 2026-03-11)
Dzhamal Chapanov: Produce state_order_status.txt containing Delivered/Cancelled/Returned/Pending/Shipped Counts per State (Due: 2026-03-11)
Nathan Luu: Produce ops_proof.txt, run script in background using Nohup Capture PID Jobs/PS Output and Tail Log (Due: 2026-03-11)
Nathan Luu: Produce trust_check_missing_values.txt for State, OrderStatus, TotalAmount, Country (Due: 2026-03-11)
Nathan Luu: Produce assumption_test_discount_range.txt validating Discount values are 0.0 – 1.0 (Due: 2026-03-11)
Bashir Hurani: Produce all 8 sections of Decision Brief in Google Document with evidence file paths (Due: 2026-03-11)
Bashir Hurani: Submit meeting1_notes.md, meeting2_notes.md, meeting2_action_items.md  (Due: 2026-03-11)

