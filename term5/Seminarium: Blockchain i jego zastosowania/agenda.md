# Agenda

Idea: Introduction to Bitcoin by breaking up Satoshi Nakamoto's paper
and a practical demonstration of some features using a local testnet (regtest).

Theoretical basis to cover:

- Original motivation - direct payments without relying on a financial institution
  - Historical context (2008 crisis?)
- Proposed solution - electronic coin as a chain of transactions
- Problem with double-spending
  - Single transaction history system
  - Earliest transaction is the correct one: timestamp server
- Proof-of-Work as a majority decision making system
  - Difficulty and its adjustment
- Network running steps
- Problem with two blockchain versions
- Incentive transaction as a motivation for honest mining, transaction fees
- Memory saving using Merkle Trees
  - Is storage a problem?
  - Simplified payment verification and dangers concerning it
- Transaction format (multiple inputs and outputs, including change)
  - Unspent transactions database (technical detail)
- Privacy (possibility to use new k/v pairs for each transaction)
  - Only the output matters
  - SatoshiDice as a how-not-to example
- Possible attack considerations and proof of safety
- Conclusion and confrontation with today's reality

Practical demonstration (depending on time left):

- Creating a key/value pair (offline)
- Transferring coins and mining blocks
- Inspecting blocks, transactions and unspent outputs (JSON)
