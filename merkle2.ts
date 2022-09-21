import { ethers } from 'ethers';
import keccak256 from 'keccak256';
import { useAccount } from 'wagmi';
import allowlistImport from './allowlist2.json';

const { MerkleTree } = require('merkletreejs')


const allowlist: {[key: string]: number} = allowlistImport;
let merkleTree: typeof MerkleTree;


export function getLeafProof(address: string){
  // if( checkAllocation(address) < 1 ){
  //     return -1
  // }
  console.log('checking allocation in leafoproof: ', checkAllocation(address))
  console.log('second stage of leaf proof')

  const hashItem = encodeLeaf(address, checkAllocation(address));
  const leaf = keccak256(hashItem)

  const proof = merkleTree.getHexRoot().getHexProof(leaf);
  console.log('prooooof');
  console.log(proof)

  return proof

}


export function getMerkleTreeRoot(){

  if(allowlist){
  const hashList = encodeLeaves(allowlist);
  console.log('hashlist', hashList)

  const merkleTree = new MerkleTree(hashList, keccak256, {
      hashLeaves: true,
      sortPairs: true
  })
  console.log('root is: ', merkleTree.getHexRoot())
  return merkleTree
}

}


export function checkAllowlisted(address: string) {

  console.log('checkallow addy: ', address);

  if( checkAllocation(address) < 1 ){
    console.log('checkallow: ', checkAllocation(address))
      return -1
  }
  if (address && typeof address !== 'undefined'){
    const merkleTree = getMerkleTreeRoot();
    console.log('treeeeeeee: ', merkleTree.getHexRoot());
    const hashItem = encodeLeaf(address, checkAllocation(address));
    const leaf = keccak256(hashItem)
    console.log('leaff2');
    console.log(leaf)
    console.log('indexxx:', merkleTree.getLeafIndex(Buffer.from(leaf)));
    const isAllowed = merkleTree.getLeafIndex(Buffer.from(leaf))
    console.log('last is allowd arg: ', isAllowed)
      return (
          isAllowed
        );
  }


}

export function checkAllocation(address: string){
  if(typeof allowlist[address] !== "undefined"){
    console.log('alllo: ', allowlist[address]);
      return allowlist[address]
  }
  return 0
}

function encodeLeaf(address: string, spots: number) {
  return ethers.utils.defaultAbiCoder.encode(["address", "uint64"],[address, spots])
}

function encodeLeaves(allowlist: {[key: string]: number}) {
  var hashList: string[] = [];

  Object.entries(allowlist).forEach(([key, value]) => {
      hashList = hashList.concat(encodeLeaf(key, value));
      
    });

  return hashList;
}