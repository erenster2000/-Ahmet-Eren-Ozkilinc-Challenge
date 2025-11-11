import { Transaction } from "@mysten/sui/transactions";

const SUI_TO_MIST_CONVERSION = 1_000_000_000n;

export const listHero = (
  packageId: string,
  heroId: string,
  priceInSui: string
) => {
  const tx = new Transaction();
  const priceInSuiBigInt = BigInt(priceInSui);
  const priceInMist = priceInSuiBigInt * SUI_TO_MIST_CONVERSION;

  tx.moveCall({
    target: `${packageId}::marketplace::list_hero`,
    arguments: [
      tx.object(heroId),
      tx.pure.u64(priceInMist),
    ],
  });

  return tx;
};
