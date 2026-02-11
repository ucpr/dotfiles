FROM denoland/deno:2.6.9

WORKDIR config

COPY . .

CMD ["bash"]
