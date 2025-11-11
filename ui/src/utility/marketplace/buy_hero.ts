import { Transaction } from "@mysten/sui/transactions";

const SUI_TO_MIST_CONVERSION = 1_000_000_000n;

export const buyHero = (packageId: string, listHeroId: string, priceInSui: string) => {
  const tx = new Transaction();
  
  const priceInMist = BigInt(priceInSui) * SUI_TO_MIST_CONVERSION;

  const [paymentCoin] = tx.splitCoins(tx.gas, [priceInMist]);

  tx.moveCall({
    target: `${packageId}::marketplace::buy_hero`,
    arguments: [
      tx.object(listHeroId),
      paymentCoin,
    ],
  });
    
  return tx;
};
